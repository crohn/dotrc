# envy theme
PROMPT='%{$fg[green]%}┌[ %{$fg_bold[magenta]%}%n@%M %{$reset_color%}%{$fg[green]%}]➜( %{$fg_bold[magenta]%}%~%{$reset_color%}%{$fg[green]%} )$(git_prompt_info)%{$reset_color%}
%{$fg[green]%}└%# % %{$reset_color%}'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="$fg[yellow]( "
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_CLEAN=" $fg[green]✔$fg[yellow] "
ZSH_THEME_GIT_PROMPT_DIRTY=" $fg[red]✗$fg[yellow] "
