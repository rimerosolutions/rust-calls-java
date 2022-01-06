#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]

use std::error::Error;
use std::{env, ptr};

include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

fn main() -> Result<(), Box<dyn Error>>{
    
    unsafe {
        let mut isolate: *mut graal_isolate_t = ptr::null_mut();
        let mut thread: *mut graal_isolatethread_t = ptr::null_mut();

        graal_create_isolate(ptr::null_mut(), &mut isolate, &mut thread);
        print_hello(thread as i64);
        graal_tear_down_isolate(thread);
    }

    Ok(())

}


