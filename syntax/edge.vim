" Edge syntax highlighting (ported from edge-vscode)
if exists("b:current_syntax")
  finish
endif

syntax include @HTML syntax/html.vim

syntax region edgeComment start=/{{--/ end=/--}}/ keepend containedin=ALL
syntax region edgeEscapedMustache start=/@{{/ end=/}}/ keepend containedin=ALL
syntax region edgeSafeMustache start=/{{{/ end=/}}}/ keepend containedin=ALL
syntax region edgeMustache start=/{{/ end=/}}/ keepend containedin=ALL

syntax keyword edgeKeyword @if @elseif @else @end @unless @each @component @slot @include @includeIf @inject @eval @vite @debugger @let @assign @newError @svg containedin=ALL
syntax match edgeTagName /@\{1,2}!\?[A-Za-z._]\+/ containedin=ALL
syntax match edgeTagLine /^\s*@\{1,2}!\?[A-Za-z._]\+\s*\~\?$/ containedin=ALL
syntax match edgeMustacheDelimiter /{{\{2,3}/ containedin=ALL
syntax match edgeMustacheDelimiter /}}\{2,3}/ containedin=ALL

highlight def link edgeComment Comment
highlight def link edgeEscapedMustache Comment
highlight def link edgeSafeMustache Special
highlight def link edgeMustache Special
highlight def link edgeKeyword Keyword
highlight def link edgeTagName Keyword
highlight def link edgeTagLine Keyword
highlight def link edgeMustacheDelimiter Special

let b:current_syntax = "edge"
