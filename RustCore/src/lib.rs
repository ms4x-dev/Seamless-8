//
//  Format.swift
//  Seamless 8
//
//  Created by Richard on 13/8/2025.
//


#![allow(clippy::not_unsafe_ptr_arg_deref)]

use std::{os::raw::c_char, ptr};
mod core;

#[no_mangle]
pub extern "C" fn rc_version() -> *const c_char {
    static VERSION: &str = concat!(env!("CARGO_PKG_NAME"), " ", env!("CARGO_PKG_VERSION"));
    VERSION.as_ptr() as *const c_char
}

#[no_mangle]
pub extern "C" fn rc_free(ptr_out: *mut u8, len: usize) {
    if !ptr_out.is_null() && len > 0 {
        unsafe { Vec::from_raw_parts(ptr_out, len, len); }
    }
}

#[no_mangle]
pub extern "C" fn rc_process_bytes(
    in_fmt: u32,
    out_fmt: u32,
    in_ptr: *const u8,
    in_len: usize,
    out_len: *mut usize,
) -> *mut u8 {
    unsafe { *out_len = 0; }
    if in_ptr.is_null() || in_len == 0 { return ptr::null_mut(); }

    let in_slice = unsafe { std::slice::from_raw_parts(in_ptr, in_len) };
    let in_fmt = match in_fmt { 0 => core::Format::Json, 1 => core::Format::Protobuf, 2 => core::Format::Binary, 3 => core::Format::Hex, _ => return ptr::null_mut() };
    let out_fmt = match out_fmt { 0 => core::Format::Json, 1 => core::Format::Protobuf, 2 => core::Format::Binary, 3 => core::Format::Hex, _ => return ptr::null_mut() };

    match core::convert_bytes(in_fmt, out_fmt, in_slice) {
        Ok(mut v) => {
            let len = v.len();
            let ptr = v.as_mut_ptr();
            std::mem::forget(v);
            unsafe { *out_len = len; }
            ptr
        }
        Err(_) => ptr::null_mut(),
    }
}
