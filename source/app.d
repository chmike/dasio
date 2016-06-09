import std.stdio, dasio;

// Define a new error category
static final class MyErrorCategory : ErrorCategory {
    mixin(makeErrorCategory!(MyErrorCategory,Value,"MyErrorCategory")());
    enum Value { Error1 = 1, Error2 }
    private enum string[int] message_ = [Error1 : "error 1", Error2 : "error 2"];
}
bool isMyErrorCategory(ErrorCode err) { return err.category is MyErrorCategory.category; }

void main() {
    ErrorCode e1 = MyErrorCategory.Error1, e2;
    assert(e1); // Has a defined error
    assert(!e2); // Has no error
    assert(e1 == MyErrorCategory.Error1);
    assert(e1.name == "MyErrorCategory.Error1");
    assert(!e1.isDasioSystemError);
    assert(e1.isMyErrorCategory);
    e2 = e1;
    writeln(e2);
    e2 = ErrorCode(3,MyErrorCategory.category);
    writeln(e2);
    e1 = ErrorCode(); // set e1 to noError
    writeln(e1);
    e1 = MyErrorCategory.Error2;
    writeln(e1);
}
