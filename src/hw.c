#include <stdio.h>
#include "test.h"

int main (
    int argc,
    char const* argv[]
)
{
    printf("hello, url=%s\n", WEBSOCKET_HOST);
    test();
    return 0;
}
