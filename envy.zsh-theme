# envy theme
PROMPT='%{$fg[cyan]%}┌[ %{$fg_bold[magenta]%}%n %{$reset_color%}%{$fg[cyan]%}]-[ %M ]➜( %{$fg_bold[magenta]%}%~%{$reset_color%}%{$fg[cyan]%} )$(git_prompt_info)%{$reset_color%}
%{$fg[cyan]%}└%# % %{$reset_color%}'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="$fg[yellow]( "
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_CLEAN=" $fg[cyan]✔$fg[yellow] "
ZSH_THEME_GIT_PROMPT_DIRTY=" $fg[red]✗$fg[yellow] "
