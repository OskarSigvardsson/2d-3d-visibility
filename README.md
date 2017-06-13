Some 2D-3D visibility experiment
================================

[Demo](https://gfycat.com/KindWelllitIbis)

I had an idea for a simple 2d/3d visibility effect, and this is the result in
Unity.  Basically it applies the "soft shadows" effect [from here](https://github.com/mattdesl/lwjgl-basics/wiki/2D-Pixel-Perfect-Shadows) to a 
3d world. 

Basically, what's happening is that there's two cameras: one 2d camera and one
3d camera. The 2d camera projects the walls into an "occlusion texture", and
that texture is used to generate the 2d visibility texture. That visibility map is
then rendered into a "cumulative visibility texture", which represents the
black/white areas in the scene. 

When it comes time to render the 3d objects, you pass the VP matrix of the
orthographic camera to the shader and project every point in the orthographic
cameras space. The UV coordinate of each vertex in the visibility textures is
passed to the fragment shader. In the fragment shader, the interpolated value is
used to figure out how to render by sampling the visibility textures. 

Obviously, many optimizations and visual improvements can be made, the most
obvious one being applying a circular blur to the visibility texture to give it
a soft blur. There are also some annoying visual artifacts, mostly related to
the visibility calculation algorithm (though those might go away as well with
some blurring). 

But this was just a weekend project for me, and I think it's kind-of a neat
trick. With some work this could be used in a proper game.

Just a warning: I haven't one through and properly cleaned up the source and
shader code, so it might be a bit messy. If you have any questions, let me know!
My email is my github username @ gmail.com.   

The code is MIT licensed, so you can pretty much do whatever with it, but if you
do use it for something, I would really appreciate to hear about it!
