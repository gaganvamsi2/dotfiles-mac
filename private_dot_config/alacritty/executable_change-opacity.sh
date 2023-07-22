#!/bin/zsh

arg1=$1
arg2=$2

calculate_modified_absolute_value() {
  local var=$1
  local modified_abs_var

  if (( var < 0 )); then
    modified_abs_var=0
  elif (( var > 1 )); then
    modified_abs_var=1
  else
    modified_abs_var=$var
  fi

  echo "$modified_abs_var"
}

# Check if arg2 is a valid floating-point number
if [[ $arg2 =~ ^[0-9]*(\.[0-9]+)$ ]]; then
  # arg2 is a valid floating-point number
  float_arg=$arg2
else
  # arg2 is not a valid floating-point number, default to 0.1
  float_arg=0.1
fi


ymlfile=~/.config/alacritty/alacritty.yml

existingOpacity=$(yq .window.opacity $ymlfile)
if [[ "$arg1" == "+" ]]; then
  result=$(calculate_modified_absolute_value $(awk '{print $1+$2}' <<<"$existingOpacity $float_arg"))
else
  if [[ "$arg1" == "-" ]]; then
    result=$(calculate_modified_absolute_value $(awk '{print $1-$2}' <<<"$existingOpacity $float_arg"))
  else
    echo "Invalid operation"
    exit 0
  fi
fi

yq eval .window.opacity=$result -i $ymlfile

yq .window.opacity $ymlfile
