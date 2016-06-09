/**
An error class to handle errors with an integer code in different categories.

Copyright: Copyright Christophe Meessen.

License:   $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors:   Christophe Meessen

Source:

*/
import std.stdio;
import std.typecons;

/**
 * An error category is derived from ErrorCategory and identified by a singleton retrieved by the `category()` method.
 * Categories can be efficiently compared by comparing their singleton address, e.g.,
 * `if (err1.category is err2.category)` or `if (err.category is MyError.category)`.
 */
class ErrorCategory
{   
    /**
     * Return the category name.
     */
    final string name() @safe pure nothrow immutable { return nameImpl(); }
    protected abstract string nameImpl() @safe pure nothrow immutable;

    /** 
     * Return the singleton instance identifying this category.
     */
    final immutable(ErrorCategory) category() @safe pure nothrow immutable { return categoryImpl(); }
    protected abstract immutable(ErrorCategory) categoryImpl() @safe pure nothrow immutable;

    /**
     * Return a human readable error code name for value.
     */
    final string name(int value) @safe pure nothrow immutable { return nameImpl(value); }
    protected abstract string nameImpl(int value) @safe pure nothrow immutable;
     
    /**
     * Return a tuple with the error code value associated to the name and hasValue set to true, 
     * or a tuple with hasValue set to false anv value to int.init if there is no such error name.
     */
    final Nullable!int value(const(char)[] name) @safe pure nothrow immutable { return valueImpl(name); }
    protected abstract Nullable!int valueImpl(const(char)[] name) @safe pure nothrow immutable;
     
    /**
     * Return a human readable description of the error associated to the specified error code value.
     */
    final string message(int value) @safe pure nothrow immutable { return messageImpl(value); }
    protected abstract string messageImpl(int value) @safe pure nothrow immutable;
    
    /**
     * Return a human readable description of the error associated to the specified error code value.
     */
    final string toString(int value) @safe pure nothrow immutable { return toStringImpl(value); }
    protected abstract string toStringImpl(int value) @safe pure nothrow immutable;
    
    /**
     * Return true if obj is this ErrorCategory
     */
    final bool opEquals(immutable ErrorCategory category) { return category is this; }
}

/**
 *  An ErrorCode identifies a particular error. It is defined by a category and by a unique integer in
 *  in that category. Like ErrorCategories, ErrorCodes are immutable singleton objects for efficient comparison, e.g.,
 *  `if (err is MyError.badAddress)` or `if (err is MyError.byCode(3))`.  
 */
struct ErrorCode
{
    this(int value, immutable ErrorCategory category) @safe pure nothrow
    {
        category_ = category;
        value_ = category ? value : 0;
    }
    
    this(T)(T.Value value) @safe pure nothrow
    {
        category_ = T.category;
        value_ = cast(int)value;
    }    
    
    ErrorCode opAssign(T)(T.Value value) @safe pure nothrow
    {
        category_ = T.category;
        value_ = cast(int)value;
        return this;
    }    
    
    int value() @safe pure nothrow const { return value_; }

    string name() @safe pure nothrow const { return category_ ? category_.name(value_) : "noError"; }

    immutable(ErrorCategory) category() @safe pure nothrow const { return category_; }

    string message() @safe pure nothrow const { return category_ ? category_.message(value_) : "no error"; }

    string toString() @safe pure nothrow const { return category_ ? category_.toString(value_) : "noError"; }

    bool opCast(T : bool)() @safe pure nothrow const { return category_ != null; }
    
    bool opEquals(ErrorCode err) @safe pure nothrow const { return err.value == value_ && err.category is category_; }

    bool opEquals(T)(T.Value value) @safe pure nothrow const { return value == value_ && T.category is category_; }
    
private:    
    Rebindable!(immutable ErrorCategory) category_ = null;
    int value_ = 0;
}

/**
 * Thrown ErrorCodeException .
 */
class ErrorCodeException : Exception
{
    @safe pure nothrow
    this(const ErrorCode err, string s = null, string fn = __FILE__, size_t ln = __LINE__)
    {
        super(s?s:err.toString(), fn, ln);
        err_ = err;
    }
    @safe pure nothrow
    this(T)(T.Value value, string s = null, string fn = __FILE__, size_t ln = __LINE__)
    {
        this(ErrorCode(value), s, fn, ln);
    }
    
    @property pure nothrow
    ErrorCode error() const { return err_; }   

    private ErrorCode err_;
}

/**
 * Template function to define the common ErrorCategory members of a user defined category
 * The user needs only to define the `pulic enum Value {...}` and `private enum string[int] message_= [...]`
 */
string makeErrorCategory(Class, Enum, string categoryName)() { 
    enum string a0 = " @safe pure nothrow ";
    enum string a1 = " @safe pure nothrow immutable ";
    string members = "private this() immutable { assert(__ctfe); } \n"
    ~"static string name()"~a0~"{ return \""~categoryName~"\"; } \n"
    ~"protected override string nameImpl()"~a1~"{ return name(); } \n"
    ~"static immutable("~Class.stringof~") category()"~a0~"{ return singleton_; } \n"
    ~"protected override immutable(ErrorCategory) categoryImpl()"~a1~"{ return category(); } \n"
    ~"static string name(int value)"~a0~"{auto p = value in value2name_; \n"
        ~"return (p) ? *p : \""~categoryName~".unknown\";} \n"
    ~"protected override string nameImpl(int value)"~a1~"{ return name(value); } \n"
    ~"import std.typecons;"
    ~"static Nullable!int value(const(char)[] name)"~a0
        ~"{auto p = name in name2value_; return (p) ? Nullable!int(*p) : Nullable!int();} \n"
    ~"protected override Nullable!int valueImpl(const(char)[] name)"~a1~"{ return value(name);} \n"
    ~"static string message(int value)"~a0~"{ import std.conv; auto p = value in message_; "
        ~"return p ? *p : \"unknown error (\"~to!string(value)~\")\";} \n" 
    ~"protected override string messageImpl(int value)"~a1~"{ return message(value); } \n"
    ~"static string toString(int value)"~a0~"{ return name(value)~\": \"~message(value); } \n"
    ~"protected override string toStringImpl(int value)"~a1~"{ return toString(value); } \n";
    string trailer = "private static singleton_ = new immutable "~Class.stringof~"; \n";
      
    string aliases; 
    string value2name = "private enum string[int] value2name_ = [";
    string name2value = "private enum int[string] name2value_ = [";
    foreach (m; __traits(allMembers, Enum)) {
        import std.string : format;
        aliases ~= format("public alias %s = %s.%s;", m, Enum.stringof, m);
        value2name ~= format("%s : \"%s.%s\",", m, categoryName, m);
        name2value ~= format("\"%s.%s\" : %s,", categoryName, m, m);
    }
    value2name ~= "];";
    name2value ~= "];";
    return members ~ "\n" ~ aliases ~ "\n" ~ value2name ~ "\n" ~ name2value ~ "\n" ~ trailer;
}


