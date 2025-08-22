fn main() -> Result<(), Box<dyn std::error::Error>> {
    prost_build::compile_protos(&["proto/record.proto"], &["proto"])?;

    println!("cargo:rerun-if-changed=proto/record.proto");
    Ok(())
}
