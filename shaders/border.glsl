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
uniform sampler2D uTextures[8];

out vec4 color;

void main() {
    if(fTexId > 0) {
        int id = int(fTexId);
        color = vec4(1.0 - fColor.r, 1.0 - fColor.g, 1.0 - fColor.b, fColor.a) * texture(uTextures[id], fTexCoords);
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
'fTexCoords' is the u/v values of the texture
'fTexId' is which texture is being taken from (max of 16 but our max is 8, can't remember...)

Time.getTime() (passed as uTime here) is seconds (with decimals) since program started
*/