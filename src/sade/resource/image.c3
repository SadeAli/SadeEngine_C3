module sade::resource::image;
import stbi;

struct Image {
    uint width;
    uint height;
    uint channels;
    char *data;
}

macro Image load(char *filename, int desired_channels = 0) {
    int width, height;
    int channels_in_file;
    char *image = stbi::load(filename, &width, &height, &channels_in_file, desired_channels); 

    return Image {
        .width = width,
        .height = height,
        .channels = (desired_channels == 0) ? channels_in_file : desired_channels,
        .data = image
    };
}

fn void Image.free(image) {
    free(image.data);
}
