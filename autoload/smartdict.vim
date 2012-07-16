" ============================================================================
" File:        smartdict.vim
" Description: Vim plugin to translate words
" Author:      Sergey Potapov (aka Blake) <blake131313 AT gmail DOT com>
" Version:     0.1
" Homepage:    http://smartdict.net
" License:     GPLv2+ -- look it up.
" Copyright:   Copyright (C) 2012 Sergey Potapov (aka Blake)
"
"              This program is free software; you can redistribute it and/or
"              modify it under the terms of the GNU General Public License as
"              published by the Free Software Foundation; either version 2 of
"              the License, or (at your option) any later version.
"
"              This program is distributed in the hope that it will be useful,
"              but WITHOUT ANY WARRANTY; without even the implied warranty of
"              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
"              General Public License for more details.
"
"              You should have received a copy of the GNU General Public License
"              along with this program; if not, write to the Free Software
"              Foundation, Inc., 59 Temple Place, Suite 330, Boston,
"              MA 02111-1307 USA
" ============================================================================




function! s:load()
ruby << END_OF_RUBY

require 'rubygems'
require 'smartdict-core'

class VimSmartdict
  DELIMITERS = [
    "(", ")", ".", ":", ";", "'", '"', "`", "~", "!", "@", "#", "$", "%",
    "^", "&", "*", "+", "=", "<", ">", "?", "_", "/", ",", " "
  ]
  DELIMETER_REGEX = Regexp.new(DELIMITERS.map{|c| Regexp.escape(c)}.join('|'))

  def self.translate_cursor
    ensure_smartidct_running
    new.translate_cursor
  end

  def self.translate(text)
    ensure_smartidct_running
    new.translate(text)
  end

  def self.ensure_smartidct_running
    unless @smartdict_running
      Smartdict.env = :user
      Smartdict.run
      @smartdict_running = true
    end
  end


  def initialize
    win = VIM::Window.current
    @row, @col = win.cursor
    @buf = VIM::Buffer.current
  end

  def translate_cursor
    translate(word_under_cursor.strip)
  end

  def translate(text)
    if text.empty?
      print "No word is found"
    else
      translator = get_translator
      translation = translator.translate(text)
      print Format.format_translation(translation)
    end
  rescue Smartdict::TranslationNotFound
    print "No translation is found for '#{text}'"
  end

  def word_under_cursor
    line     = @buf[@row]
    start_at = @col
    end_at   = @col

    while start_at > 0 && line[start_at-1] !~ DELIMETER_REGEX
      start_at -= 1
    end

    while ((char = line[end_at+1]) && char !~ DELIMETER_REGEX)
      end_at += 1
    end

    line[start_at..end_at]
  end

  def get_translator
    Smartdict::Translator.new(get_opts)
  end

  def get_opts
    opts = {}
    opts[:from_lang] = VIM.evaluate('g:SmartdictFromLang')
    opts[:to_lang]   = VIM.evaluate('g:SmartdictToLang')
    opts[:driver]    = VIM.evaluate('g:SmartdictDriver')
    opts[:log]       = VIM.evaluate('g:SmartdictLog').to_s == '0' ? false : true
    opts
  end


  class Format < Smartdict::Formats::AbstractFormat
    def format_translation(translation)
      result = ""
      translated_words = translation.translated.values.map{|words| words.first(3)}.flatten
      transcription = translation.transcription

      result << translation.word
      result << " [#{transcription}] " if transcription
      result << " - "
      result << translated_words.join(", ")
      result
    end

    def format_list(translations)
      raise NotImplementedError
    end
  end
end

END_OF_RUBY
endfunction


function! s:init()
    if(!(exists('s:loaded') && s:loaded))
        call s:load()
        let s:loaded = 1
    endif
endfunction


function! smartdict#translate_cursor()
    call s:init()
ruby <<END_OF_RUBY
    VimSmartdict.translate_cursor
END_OF_RUBY
endfunction


function! smartdict#translate(text)
    call s:init()
ruby << END_OF_RUBY
    text = VIM.evaluate('a:text')
    VimSmartdict.translate(text)
END_OF_RUBY
endfunction
