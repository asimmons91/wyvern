# Wyvern

A set of libraries for DragonRuby. They provide an opinionated way to
and structure games, and have been extracted from my own games built with DragonRuby.
A lot of it takes inspiration from the wider Ruby ecosystem and other game frameworks.

## WyvernSupport

Inspired by Rails' [ActiveSupport](https://guides.rubyonrails.org/active_support_core_extensions.html),
this provides small quality of life improvements to core mRuby/DragonRuby. Other Wyvern libraries also
depend on `WyvernSupport`.

## WyvernScene

A scene graph library that takes heavy inspiration from LibGDX's
[Scene2D](https://libgdx.com/wiki/graphics/2d/scene2d/scene2d). It provides a framework to
structure your game's data & logic using a combination of Scenes, Actors, and Behaviors.

## Installation
Copy `wyvernsupport/lib` and/or `wyvernscene/lib` into your project directory and require them as needed.

For easier dependency management I'd recommend the awesome tool
[Foodchain](https://github.com/pvande/foodchain/) to manage your game's dependencies.

```ruby
# dependencies.rb
require "path/to/foodchain"

# WyvernSupport
github :asimmons91, :wyvern, "wyvernsupport/lib", destination: "vendor/wyvernsupport"

# WyvernScene
github :asimmons91, :wyvern, "wyvernscene/lib", destination: "vendor/wyvernscene"
```

Each library follows the same structure,
```
├── wyvern_support
│   └── rest_of_lib_files
└── wyvern_support.rb # this requires all the necessary components of the library
```
so you only need to require the main `lib_name.rb` file from your game.
