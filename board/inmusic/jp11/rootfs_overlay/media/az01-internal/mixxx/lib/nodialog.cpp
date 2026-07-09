// LD_PRELOAD shim for EGLFS: block all QWidget::setVisible(true) calls
#include <cstdio>
#include <unistd.h>
#include <dlfcn.h>

extern "C" {

void _ZN7QWidget10setVisibleEb(void* self, bool visible) {
    static void (*real_fn)(void*, bool) = nullptr;
    if (!real_fn) {
        real_fn = (void (*)(void*, bool))dlsym(RTLD_NEXT, "_ZN7QWidget10setVisibleEb");
    }
    if (visible) {
        fprintf(stderr, "nodialog: BLOCKED setVisible(true) ptr=%p\n", self);
        return;
    }
    if (real_fn) real_fn(self, visible);
}

}
