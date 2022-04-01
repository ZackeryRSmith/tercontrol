# Ok ok ok
I will be maintaining the Cython version of Tercontrol (new releases will not be made but the PYPI repo will be up to date with a changelog!). I will be keeping the C version maintained, it will be favored over the Cython version aswell. I will not neglect the python version though!


<h1 align="center">TerControl</h1>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-tercontrol">About TerControl</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#build">Build</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#thanks">Thanks</a></lu>
  </ol>
</details>

  
<!--
Start of about
-->
###### <a name="about-tercontrol" />
**TerControl** is a lightweight opinion based POSIX terminal control library for python3. TerControl gives the end-user all the tools needed to manipulate the terminal (Look at [features](#features) for a full list of features). 

TerControl was created to suit my needs for terminal control without having to rely on Curses or NCurses wrappings, thus TerControl is heavily influenced by my needs. I'm very open to ideas and suggestions so if you have an idea open an issue with a feature request! 
<!--
End of about
-->

<!--
Start of features
-->
## Features <a name="features" />

- No dependencies (other then python's standard library) 
- Terminfo support
- Cursor
    - Move the cursor N times (up, down, left, right)
    - Set/get the cursor position
    - Hide/show the cursor
- Styled output 
    - Foreground color (16 base colors)
    - Background color (16 base colors)
    - 256 (ANSI) color support
    - RGB color support
    - Text attributes (bold, dim, italic, underscore, crossed, reversed, blink, invisible)
- Terminal 
    - Clear (all lines, current line, from cursor down and up, clear partial)
    - Get the terminal size
    - Save/restore screen
    - Alternate screen
    - Exit alternate screen
- Event
    - Input Events 
<!--
End of features
-->

<!-- 
Start of installation
-->
## Installation <a name="installation" />
To install the experimental pip version do
```
pip install tercontrol
```
Please give me any and all feedback by creating an [issue](https://github.com/ZackeryRSmith/tercontrol/issues)! This greatly helps, I hope to have any PYPI bugs patched by version 1.0.5!
<!--
End of installation
-->

<!--
Start of build
-->
## Build <a name="build" />
If you insist you can build TerControl
1. Enter TerControl's directory
2. Run the commands: 
  ```
  python3 setup.py sdist bdist_wheel
  auditwheel repair dist/<your_wheel_name>
  mv wheelhouse/* dist
  rm dist/*-cp38-cp38-linux_x86_64.whl
  ```
3. Enter the dist directory
4. Open the .whl file with an archive utility
5. Extract the `.so` file
6. Place the `.so` file into your project
7. import it E.g. `from tercontrol import *`
<!--
End of build
-->

<!--
Start of contributing
-->
## Contributing <a name="contributing" />
Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
<!--
End of contributing
-->

<!--
Start of licence
-->
## Licence <a name="license" />
All code is distributed under the [GNU GPLv3 licence](https://github.com/ZackeryRSmith/tercontrol/blob/main/LICENSE)
<!--
End of licence
-->

<!--
Start of contact
-->
## Contact <a name="contact" />
Contact me via email or discord
- zackery.smith82307@gmail.com
- Dumb Bird#8147
<!--
End of contact
-->

<!--
Start of thanks
-->
## Thanks <a name="thanks">
I would like to thank the entirety of the [Program Dream](https://discord.gg/gfmaxgE) discord server for being a great place! Personally being active there gave me a new thing to do, I bet I'll be active on there a lot more so join! It's a non-toxic programming community and it's just a great place to be!
<!--
End of thanks
-->
