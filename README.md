# dasio
The goal of this project is to port **asio** of **boost** to D.

As the intent is a full rewrite of asio in pure D, it is also a good opportunity 
for me to learn D and evaluate it's potential use for efficent I/O application.

The asio library is the product of a long maturation process by expert C++ programmers.
Design choices have been driven by portability and efficiency requirements. I use asio
in an application at work and its performances and simplicity of use are outstanding. 

The sources of asio are visible [here](https://github.com/chriskohlhoff/asio).

## ErrorCode

An error code is a struct with two fields : 
- an int holding the error code value
- a pointer to a singleton ErrorCategory object. 

It is thus possible to define different error category without confict with the integer values. 
A user would simply have to define its own ErrorCategory class to define his own category of errors. 

```
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
```
