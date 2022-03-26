<h1 align="center">TerControl</h1>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-tercontrol">About TerControl</a>
      <a href="#features">Features</a>
    </li>
    <li>
      <a href="#installation">Installation</a>
    </li>
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
**TerControl** is a lightweight opinion based POSIX terminal control library for python2 & python3. TerControl gives the end-user all the tools needed to create a terminal application (Look at [features](#features) for a full list of features). 

TerControl was created to suit my needs for terminal control without having to rely on Curses or NCurses wrappings, thus TerControl is heavily influenced by my needs. I'm very open to ideas and suggestion so open an issue with a feature request! 
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
    - Text attributes (bold, dim, italic, underscore, crossed, reversed, blink, invisible)
- Terminal 
    - Clear (all lines, current line, from cursor down and up)
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
## Installation
As of right now I don't plan on making this a PYPI package unless this actully gains any attraction. If you would like to use TerControl: 
1. download tercontrol.py
2. Place tercontrol.py into your projects directory
3. import tercontrol I.e. `from tercontrol import *`


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

## Licence <a name="license" />
All code is distributed under the [GNU GPLv3 licence](https://github.com/ZackeryRSmith/tercontrol/blob/main/LICENSE)

## Contact <a name="contact" />
Contact me via email or discord
- zackery.smith82307@gmail.com
- Dumb Bird#8147

## Thanks <a name="thanks">
I would like to thank the entirety of the [Program Dream](https://discord.gg/gfmaxgE) discord server for being a great place! Personally being active there for only a few days gave me a new thing to do, I bet I'll be active on there a lot more so join! It's a non-toxic programming community and it's just a great place to be!
