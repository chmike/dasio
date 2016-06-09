/**
A system error category.

Copyright: Copyright Christophe Meessen.

License:   $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors:   Christophe Meessen

Source:
*/
import error_code;
import core.stdc.errno;
import std.typecons;



/**
 * Return true if err is a SystemError, e.g., `if (err.isSystemError)`.
 */
bool isDasioSystemError(ErrorCode err) { return err.category is SystemError.category; }


/** 
 *  Posix system errors for dasio.
 */
final class SystemError : ErrorCategory
{
    mixin(makeErrorCategory!(SystemError,Value,"dasio.SystemError")());
    // pragma(msg, makeErrorCategory!(SystemError,Value,"dasio.SystemError"));

    /**
     *  Defined error codes.
     */
version (Posix) {
    import core.stdc.errno;
    enum Value {
        accessDenied              = EACCES,        /// Permission denied.
        addressFamilyNotSupported = EAFNOSUPPORT,  /// Address family not supported by protocol.
        addressInUse              = EADDRINUSE,    /// Address already in use.
        alreadyConnected          = EISCONN,       /// Transport endpoint is already connected.
        alreadyStarted            = EALREADY,      /// Operation already in progress.
        brokenPipe                = EPIPE,         /// Broken pipe.
        connectionAborted         = ECONNABORTED,  /// A connection has been aborted.
        connectionRefused         = ECONNREFUSED,  /// Connection refused.
        connectionReset           = ECONNRESET,    /// Connection reset by peer.
        badDescriptor             = EBADF,         /// Bad file descriptor.
        badAddress                = EFAULT,        /// Bad address.
        hostUnreachable           = EHOSTUNREACH,  /// No route to host.
        inProgress                = EINPROGRESS,   /// Operation now in progress.
        interrupted               = EINTR,         /// Interrupted system call.
        invalidArgument           = EINVAL,        /// Invalid argument.
        messageSize               = EMSGSIZE,      /// Message too long.
        nameTooLong               = ENAMETOOLONG,  /// The name was too long.
        networkDown               = ENETDOWN,      /// Network is down.
        networkReset              = ENETRESET,     /// Network dropped connection on reset.
        networkUnreachable        = ENETUNREACH,   /// Network is unreachable.
        noDescriptors             = EMFILE,        /// Too many open files.
        noBufferSpace             = ENOBUFS,       /// No buffer space available.
        noMemory                  = ENOMEM,        /// Cannot allocate memory.
        noPermission              = EPERM,         /// Operation not permitted.
        noProtocolOption          = ENOPROTOOPT,   /// Protocol not available.
        noSuchDevice              = ENODEV,        /// No such device.
        notConnected              = ENOTCONN,      /// Transport endpoint is not connected.
        notSocket                 = ENOTSOCK,      /// Socket operation on non-socket.
        operationAborted          = ECANCELED,     /// Operation cancelled.
        operationNotSupported     = EOPNOTSUPP,    /// Operation not supported.
        shutDown                  = ESHUTDOWN,     /// Cannot send after transport endpoint shutdown.
        timedOut                  = ETIMEDOUT,     /// Connection timed out.
        tryAgain                  = EAGAIN,        /// Resource temporarily unavailable.
        wouldBlock                = EWOULDBLOCK    /// The operation would block.
    }
} else version(Windows) {
    import core.sys.windows;
    enum Value {
        accessDenied              = WSAEACCES,             /// Permission denied.
        addressFamilyNotSupported = WSAEAFNOSUPPORT,       /// Address family not supported by protocol.
        addressInUse              = WSAEADDRINUSE,         /// Address already in use.
        alreadyConnected          = WSAEISCONN,            /// Transport endpoint is already connected.
        alreadyStarted            = WSAEALREADY,           /// Operation already in progress.
        brokenPipe                = ERROR_BROKEN_PIPE,     /// Broken pipe.
        connectionAborted         = WSAECONNABORTED,       /// A connection has been aborted.
        connectionRefused         = WSAECONNREFUSED,       /// Connection refused.
        connectionReset           = WSAECONNRESET,         /// Connection reset by peer.
        badDescriptor             = WSAEBADF,              /// Bad file descriptor.
        badAddress                = WSAEFAULT,             /// Bad address.
        hostUnreachable           = WSAEHOSTUNREACH,       /// No route to host.
        inProgress                = WSAEINPROGRESS,        /// Operation now in progress.
        interrupted               = WSAEINTR,              /// Interrupted system call.
        invalidArgument           = WSAEINVAL,             /// Invalid argument.
        messageSize               = WSAEMSGSIZE,           /// Message too long.
        nameTooLong               = WSAENAMETOOLONG,       /// The name was too long.
        networkDown               = WSAENETDOWN,           /// Network is down.
        networkReset              = WSAENETRESET,          /// Network dropped connection on reset.
        networkUnreachable        = WSAENETUNREACH,        /// Network is unreachable.
        noDescriptors             = WSAEMFILE,             /// Too many open files.
        noBufferSpace             = WSAENOBUFS,            /// No buffer space available.
        noMemory                  = ERROR_OUTOFMEMORY,     /// Cannot allocate memory.
        noPermission              = ERROR_ACCESS_DENIED,   /// Operation not permitted.
        noProtocolOption          = WSAENOPROTOOPT,        /// Protocol not available.
        noSuchDevice              = ERROR_BAD_UNIT,        /// No such device.
        notConnected              = WSAENOTCONN,           /// Transport endpoint is not connected.
        notSocket                 = WSAENOTSOCK,           /// Socket operation on non-socket.
        operationAborted          = ERROR_OPERATION_ABORTED,/// Operation cancelled.
        operationNotSupported     = WSAEOPNOTSUPP,         /// Operation not supported.
        shutDown                  = WSAESHUTDOWN,          /// Cannot send after transport endpoint shutdown.
        timedOut                  = WSAETIMEDOUT,          /// Connection timed out.
        tryAgain                  = ERROR_RETRY,           /// Resource temporarily unavailable.
        wouldBlock                = WSAEWOULDBLOCK         /// The operation would block. 
    }
} else {
    static assert(false, "Unsupported plateform");
}

    private enum string[int] message_= [
        accessDenied              : "permission denied",
        addressFamilyNotSupported : "bddress family not supported by protocol",
        addressInUse              : "bddress already in use",
        alreadyConnected          : "transport endpoint is already connected",
        alreadyStarted            : "operation already in progress",
        brokenPipe                : "broken pipe",
        connectionAborted         : "a connection has been aborted",
        connectionRefused         : "connection refused",
        connectionReset           : "connection reset by peer",
        badDescriptor             : "bad file descriptor",
        badAddress                : "bad address",
        hostUnreachable           : "no route to host",
        inProgress                : "operation now in progress",
        interrupted               : "interrupted system call",
        invalidArgument           : "invalid argument",
        messageSize               : "message too long",
        nameTooLong               : "the name was too long",
        networkDown               : "network is down",
        networkReset              : "network dropped connection on reset",
        networkUnreachable        : "network is unreachable",
        noDescriptors             : "too many open files",
        noBufferSpace             : "no buffer space available",
        noMemory                  : "cannot allocate memory",
        noPermission              : "operation not permitted",
        noProtocolOption          : "protocol not available",
        noSuchDevice              : "no such device",
        notConnected              : "transport endpoint is not connected",
        notSocket                 : "socket operation on non-socket",
        operationAborted          : "operation cancelled",
        operationNotSupported     : "operation not supported",
        shutDown                  : "cannot send after transport endpoint shutdown",
        timedOut                  : "connection timed out",
        tryAgain                  : "resource temporarily unavailable",
        wouldBlock                : "the operation would block"
    ];

}


/// 
unittest
{
    import dasio;
    
    // Different ways to specify 'no error'
    ErrorCode e0; // By default error code is defined as no Error
    if (!e0) assert(true); // Test if noError
    if (e0) assert(false); // Test if there is an error
    
    // Properties of noError 
    assert(e0.category is null); // The error category is null when NoError
    assert(e0.value is 0);
    assert(e0.name == "noError");
    assert(e0.message == "no error");
    assert(e0.toString == "noError");
    
    // Assign noError value
    e0 = ErrorCode();
    assert(!e0);
    
    // A null category means noError
    e0 = ErrorCode(1234,null);
    assert(!e0);
    assert(e0.category is null);
    assert(e0.value is 0);

    // Define e1 as an error value 
    ErrorCode e1 = dasio.SystemError.badAddress;
    assert(e1);
    assert(e1 == dasio.SystemError.badAddress);
    assert(e1.category is dasio.SystemError.category);
    assert(e1.category == dasio.SystemError.category); // Using 'is' is more efficient
    assert(e1.isDasioSystemError);
    assert(e1.value is dasio.SystemError.badAddress);
    assert(e1.value == dasio.SystemError.badAddress); // same performance as 'is' because value is an int
    assert(e1.name == "dasio.SystemError.badAddress");
    assert(e1.message == "bad address");
    assert(e1.toString == "dasio.SystemError.badAddress: bad address");
    
    // Assignement works too
    e1 = dasio.SystemError.wouldBlock;
    assert(e1 == dasio.SystemError.wouldBlock);
    
    // Define an error that isn't predefined
    e1 = ErrorCode(123456, dasio.SystemError.category);
    assert(e1.name == "dasio.SystemError.unknown");
    assert(e1.message == "unknown error (123456)");
    
    // ErrorCode comparison
    assert(e0 != e1);
    assert(e0 !is e1);
    e0 = e1;
    assert(e0 == e1);
    assert(e0 is e1);
    
    // Accessing some properties of categories
    assert(dasio.SystemError.name == "dasio.SystemError");
    immutable dasio.ErrorCategory c = dasio.SystemError.category; 
    assert(c.name == "dasio.SystemError"); // name() is also a virtual method
    // Getting error string name by value
    assert(dasio.SystemError.name(dasio.SystemError.badAddress) == "dasio.SystemError.badAddress");
    assert(dasio.SystemError.name(123456) == "dasio.SystemError.unknown");
    // Getting error string message by value
    assert(dasio.SystemError.message(dasio.SystemError.badAddress) == "bad address");
    assert(dasio.SystemError.message(123456) == "unknown error (123456)");
    // Getting error value by string name
    import std.typecons;
    Nullable!int res1 = dasio.SystemError.value("dasio.SystemError.badAddress"); 
    assert(!res1.isNull);
    assert(res1 is dasio.SystemError.badAddress);
    Nullable!int res2 = dasio.SystemError.value("xxx"); 
    assert(res2.isNull);
    
    // An ErrorCode can be thrown as an exception
    try {
        throw new ErrorCodeException(dasio.SystemError.badAddress);
    }
    catch (ErrorCodeException e)
    {
        assert(e.error.isDasioSystemError);
        assert(e.error == dasio.SystemError.badAddress);       
        assert(e.error.name == "dasio.SystemError.badAddress");
    }
    
    // Recommended way to return an error code from a function
    void foo(out ErrorCode e)
    {
        // ...
        e = dasio.SystemError.brokenPipe;
    }
    ErrorCode e2;
    foo(e2);
    assert(e2 == dasio.SystemError.brokenPipe);

    // Using switch statement to handle different error code values
    if (e2.isDasioSystemError) // follow up on error returned by foo(e2)
    {
        switch(e2.value) { 
        case dasio.SystemError.wouldBlock: assert(false); //break;
        case dasio.SystemError.brokenPipe: assert(true); break;
        case dasio.SystemError.badAddress: assert(false); // break;
        default: assert(false); //break;
        }
    }
    
    // Define a new error category
    static final class MyCategory : ErrorCategory {
        mixin(makeErrorCategory!(MyCategory,Value,"MyCategory")());
        // pragma(msg, makeErrorCategory!(MyCategory,Value,"MyCategory"));

        enum Value {
            Error1 = 1,
            Error2
        }
        private enum string[int] message_ = [
            Error1 : "this is erron 1",
            Error2 : "this is error 2"
        ];
    }
    // Define a handy category test
    bool isMyCategory(ErrorCode err) { return err.category is MyCategory.category; }
    
    ErrorCode e3 = MyCategory.Error1;
    assert(e3);
    assert(e3.name == "MyCategory.Error1");
    assert(!e3.isDasioSystemError);
    assert(isMyCategory(e3)); // UFCS doesn't work for functions defined in code
}