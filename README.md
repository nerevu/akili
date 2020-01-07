# akili

![akili-screenshot](app/assets/images/github_akili.png)

## Introduction

akili is a [Brunch](http://brunch.io) and [Chaplin](http://chaplinjs.org) web app for creating responsive choropleths.

## Requirements

akili has been tested on the following configuration:

- MacOS X 10.9.5
- [Brunch](https://brunch.io) (required)
- [Chaplin](https://chaplinjs.org) (required)
- [Node.js](http://nodejs.org) (required)
- [Bower](http://bower.io) (required)
- [Coffeescript](http://coffeescript.org/) (required to run a production server)

## Setup

*Install node (if you haven't already)*

MacOS X

    sudo port install node

or

    brew install node

*Install requirements (if you haven't already)*

```bash
npm install -g brunch
npm install -g bower
npm install -g coffee-script
```

*Development versions*

```bash
$ node --version
v4.4.5
$ npm --version
5.0.3
$ brunch --version
2.10.9
$ bower --version
1.8.0
$ coffee --version
CoffeeScript version 1.12.6
```

## Installation

```bash
git clone https://github.com/nerevu/akili.git
cd akili
npm install
```

## Usage

*Run development server (continuous rebuild mode)*

    brunch watch --server

*Run production node server*

    coffee server.coffee

*Build html/css/js files (will appear in `public/`)*

    brunch build

*Build html and minified css/js files (will appear in `public/`)*

    brunch build --production

## License

akili is distributed under the [MIT License](http://opensource.org/licenses/MIT).
