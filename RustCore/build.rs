fn main() -> Result<(), Box<dyn std::error::Error>> {
    prost_build::compile_protos(&["proto/record.proto"], &["proto"])?;

    let crate_dir = std::env::var("CARGO_MANIFEST_DIR")?;
    let out_path = std::path::Path::new(&crate_dir).join("rust_core.h");
    cbindgen::Builder::new()
        .with_crate(crate_dir)
        .with_language(cbindgen::Language::C)
        .with_include_version(true)
        .generate()
        .expect("cbindgen failed")
        .write_to_file(out_path);

    println!("cargo:rerun-if-changed=proto/record.proto");
    Ok(())
}
