# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  check 'lib'
  signature 'sig'
  ignore(
    'lib/rbs_goose/examples'
  )
  configure_code_diagnostics(D::Ruby.default)
end
