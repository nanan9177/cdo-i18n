# Fixes two issues in Yaml files:
# 1) The locale keys must be quoted, otherwise Norwegian's `no: 1`
#    is parsed as `{false=>1}`.
# 2) All translated messages should be quoted.

while(<>) {
  if (/(.*(get_a_certificate_message|beyond_hour_message).*)learn'(.*)/) {
    print "${1}learn/beyond'${3}\n";
  } else {
    print;
  }
}
