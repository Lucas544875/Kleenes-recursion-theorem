Z = ->(f) {
  ->(x){
    f.(
      ->(y) {x.(x).(y)}
    )
  }.(
    ->(x){
      f.(
        ->(y) {x.(x).(y)}
      )
    }
  )
}