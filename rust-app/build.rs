extern crate bindgen;

use std::env;
use std::path::PathBuf;

fn main() {
    let path = env::var("LIBHELLOAPI_PATH").unwrap_or("../java-lib/build/native/nativeBuild".to_string());

    if !PathBuf::from(path.clone()).exists() {
        let mut msg = "Please make sure that the dependent java-lib project has been built.".to_string();
        msg.push_str("\nAdditionally, if the java-lib project location is not relative to this rust project folder");
        msg.push_str("then you can provide a LIBHELLOAPI_PATH environment variable pointing to the location of generated C headers and so files.");
        panic!("{}", msg);
    }

    println!("cargo:rustc-link-lib=helloapi");
    println!("cargo:rustc-link-search={path}", path=path);

    let bindings = bindgen::Builder::default()
        .header(format!("{path}/libhelloapi.h", path=path))
        .clang_arg(format!("-I{path}", path=path))
        .generate()
        .expect("Unable to generate bindings");
    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings.write_to_file(out_path.join("bindings.rs")).expect("Could not write bindings!");
}
