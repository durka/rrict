use std::fs::File;
use std::io::Write;
use std::time::{SystemTime, UNIX_EPOCH};

fn main() {
    let mut f = File::create("src/inc.rs").unwrap();
    writeln!(f, "const TIME: u64 = {};", SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs()).unwrap();

    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-changed=dir");
    println!("cargo:rerun-if-changed=dir/foo");
}

