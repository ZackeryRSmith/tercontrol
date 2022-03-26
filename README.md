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
As of right now I don't plan on making this a PYPI package unless this actully gains any attraction. If you would like to use TerControl: 
1. download one of the builds from the [releases](https://github.com/ZackeryRSmith/cval/releases)
2. Place the compiled binary into your projects directory
3. import tercontrol I.e. `from tercontrol import *`
<!--
End of installation
-->

<!--
Start of build
-->
## Build <a name="build" />
I am currently working on optimising TerControl. I have switched to using a cython module to speed up code. If the compiled binary I supplied in the [releases](https://github.com/ZackeryRSmith/cval/releases) does not work please compile your own.
1. Enter TerControl's directory
2. Run `python setup.py build_ext --inplace`
3. Your compiled binary should be in the same directory
4. Place the compiled binary into your project
5. import it E.g. `from tercontrol import *`
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
