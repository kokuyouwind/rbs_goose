# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  check 'lib'
  signature 'sig', 'sig_ext'
  configure_code_diagnostics(D::Ruby.default) do |hash|
    hash[D::Ruby::BlockTypeMismatch] = :information
    hash[D::Ruby::RequiredBlockMissing] = :information
  end
end
