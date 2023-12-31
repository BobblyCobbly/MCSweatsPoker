#type vertex;
#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec4 aColor;
layout (location = 2) in vec2 aTexCoords;
layout (location = 3) in float aTexId;


uniform mat4 uProjection;
uniform mat4 uView;


out vec4 fColor;
out vec2 fTexCoords;
out float fTexId;

void main() {

    vec2 uv = aTexCoords;


    fColor = aColor;
    fTexCoords = aTexCoords;
    fTexId = aTexId;
    gl_Position = uProjection * uView * vec4(aPos, 1.0);
}

    #type fragment;
    #version 330 core

in vec4 fColor;
in vec2 fTexCoords;
in float fTexId;

uniform float uTime;
uniform vec2 uDims;
uniform vec3 uBorderColor;
uniform sampler2D uTextures[8];

out vec4 color;

bool isTransparent(vec2 uv) {
    if(uv.x <= 0 || uv.y <= 0 || uv.x >= uDims.x || uv.y >= uDims.y) {
        return false;
    }
    return texture(uTextures[int(fTexId)], vec2(uv.x / uDims.x, uv.y / uDims.y)).a < 0.1;
}

bool isBorder(vec2 uv) {
    return !(
    isTransparent(vec2(uv.x - 1.0, uv.y - 1.0)) ||
    isTransparent(vec2(uv.x, uv.y - 1.0)) ||
    isTransparent(vec2(uv.x + 1.0, uv.y - 1.0)) ||
    isTransparent(vec2(uv.x - 1.0, uv.y)) ||
    isTransparent(vec2(uv.x + 1.0, uv.y)) ||
    isTransparent(vec2(uv.x - 1.0, uv.y + 1.0)) ||
    isTransparent(vec2(uv.x, uv.y + 1.0)) ||
    isTransparent(vec2(uv.x + 1.0, uv.y + 1.0)));
}

void main() {

    if(fTexId > 0) {
        int id = int(fTexId);
        vec2 uv = vec2(fTexCoords.x * uDims.x, fTexCoords.y * uDims.y);
        vec4 texColor = texture(uTextures[id], fTexCoords);
        color = isBorder(uv) ? vec4(fColor.rgb, fColor.a) : vec4(uBorderColor, texColor.a);
    } else {
        color = fColor;
    }
}



/*
Notes about shaders:
Vertex shaders deal with position
Fragment shaders deal with modifying image
'uniform' variables are like constants (Only passed once per frame, not every single pixel)
'in' variables are expected inputs
'out' variables are the result of the main() functions
Every 'out' variable in vertex shader should have the same 'in' variable in fragment shader
'sampler2D' is the variable type for 2D images apparently?
'fTexCoords' is the NOMRALIZED (0 - 1) u/v values of the texture, it is also based off the ENTIRE TEXTURE of a spritesheet, not just the part you are using.
'fTexId' is which texture is being taken from (max of 16 but our max is 8, can't remember...)

Time.getTime() (passed as 'uTime' here) is seconds (with decimals) since program started
*/