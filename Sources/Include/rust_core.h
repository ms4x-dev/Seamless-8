/* Generated with cbindgen:0.27.0 */

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

const char *rc_version(void);

void rc_free(uint8_t *ptr_out, uintptr_t len);

/**
 * Process in-memory bytes for: JSON, Protobuf, Binary, Hex.
 * Returns newly-allocated buffer; caller must free with rc_free.
 * out_len is set to size of returned buffer.
 * On error returns null and sets out_len=0.
 */
uint8_t *rc_process_bytes(uint32_t in_fmt,
                          uint32_t out_fmt,
                          const uint8_t *in_ptr,
                          uintptr_t in_len,
                          uintptr_t *out_len);
