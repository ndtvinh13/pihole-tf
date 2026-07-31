# One-time state migration. Safe to delete after a successful apply.

moved {
  from = pihole_domain.allow_test_com
  to   = pihole_domain.deny["deny_examptest_com"]
}