# vim-smartdict - Vim plugin to translate words (dictionary)
by [Sergey Potapov](https://github.com/greyblake) (aka Blake)


## Intro

Vim-smartdict is wrapper around Smardict dictionary which allows you to use
Smardict inside Vim.
Smartdict is dictionary designed to improve you knowledge of foreign
language. It can use different data sources (called drivers) like
GoogleTranslate or LigvoYandex.
To get more information about Smartdict please visit
[Smartdict home page](http://smartdict.net/)


## Usage

Quick config (translate from English to German with GoogleTranslate):

```
    let g:SmartdictFromLang='en'
    let g:SmartdictToLang='de'
    let g:SmartdictDriver='google_translate'
```

Let's say you have the text:

```
    Hel*lo world!
```

Press `<Leader>T` and you'll show the next output:

```
    Hello - Hallo, Guten Tag, Servus
``

## Dependencies

The plugin requires a builtin ruby interpreter. It means that your Vim
should be compiled with `--enable-rubyinterp` option.
To find out does your Vim have builtin ruby interpreter you can do the next:
    :echo has('ruby')

If output is `1` the ruby interpreter is builtin.

Then you need to install `smartdict-core` gem:

```
    gem install smartdict-core
```

Also it's recommended to use ruby1.9.3, since 1.9.2 is buggy.
Read [how to build Vim againts Ruby1.9.3](http://greyblake.com/blog/2012/07/15/how-to-build-vim-against-specific-ruby-version/)


## Installation

To install the plugin just copy `autoload`, `plugin`, `doc` directories into your .vim directory.


## Credits

* [Sergey Potapov](https://github.com/greyblake) - creator and maintainer, http://greyblake.com


## License

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of
the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston,
MA 02111-1307 USA
