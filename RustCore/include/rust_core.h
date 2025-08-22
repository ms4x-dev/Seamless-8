#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

extern "C" {

const char *rc_version();

void rc_free(uint8_t *ptr_out, uintptr_t len);

uint8_t *rc_process_bytes(uint32_t in_fmt,
                          uint32_t out_fmt,
                          const uint8_t *in_ptr,
                          uintptr_t in_len,
                          uintptr_t *out_len);

}  // extern "C"
