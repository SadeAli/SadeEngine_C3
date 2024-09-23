#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

extern stbi_uc *stbi_load(const char *filename, int *x, int *y, int *channels_in_file, int desired_channels);
