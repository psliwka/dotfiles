function cdpr --description 'cd to project\'s root directory'
  cd (git rev-parse --show-toplevel)
end
