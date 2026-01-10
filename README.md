# Ash Dynamics
> Note: This library is heavy alpha.

Robotics simulation and training.

## Installation

### Ubuntu
Note, this will attempt to build ffmpeg from source. 
This project is build to be binded against ffmpeg 8.0 which has not been released
yet as an installable deb package.
```
# For encoding video and simulations into h264, the encoder must be installed
# user side / and separately:
# Per https://www.openh264.org/BINARY_LICENSE.txt
# It is important for the end user to be aware of 
# https://via-la.com/licensing-programs/avc-h-264/#license-fees if they intend
# to use the encoder in commercial solutions.

pixi shell
export CONFIGURE_LIBOPENH264=true
pixi run configure
pixi run test_all
```

## Demo Video
Important: This video is just for current status / capability purposes. This is not
UX friendly since the memory usage / origin API is very premature. 

Additionally, this requires a version of mojo that implements:
https://github.com/modular/modular/pull/5715

```
mkdir -p test_data/dash_mojo
pixi run test tests/test_ffmpeg/test_ffmpeg_h264_to_fmp4.mojo
python3 serve_dash.py 
```

https://github.com/user-attachments/assets/a7d5064c-a636-4130-b443-4dfde792f00a

## Developer Notes
If working in cursor, you can change the editor to use cursor instead.
```
git config core.editor "cursor --wait"
```


## License

Distributed under the Apache 2.0 License with LLVM Exceptions. See [LICENSE](https://github.com/Mojo-Numerics-and-Algorithms-group/NuMojo/blob/main/LICENSE) and the LLVM [License](https://llvm.org/LICENSE.txt) for more information.

This project includes code from [Mojo Standard Library](https://github.com/modular/modular), licensed under the Apache License v2.0 with LLVM Exceptions (see the LLVM [License](https://llvm.org/LICENSE.txt)). MAX and Mojo usage and distribution are licensed under the [MAX & Mojo Community License](https://www.modular.com/legal/max-mojo-license).