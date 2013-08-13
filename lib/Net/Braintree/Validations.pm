package Net::Braintree::Validations;
use strict;

use Net::Braintree::Util;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS );
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(verify_params address_signature credit_card_signature customer_signature transaction_signature clone_transaction_signature merchant_account_signature);

sub verify_params {
  my ($params, $white_list) = @_;
  foreach(keys %$params) {
    my $key = $_;
    my $sub_white_list = $white_list-> {$key};
    return 0 unless($sub_white_list);
    if (is_hashref($sub_white_list)) {
      return 0 unless verify_params($params->{$key}, $sub_white_list);
    } elsif (is_hashref($params->{$key})) {
      return 0 if $sub_white_list ne "_any_key_";
    }
  }
  return 1;
}

sub address_signature {
  return {
    company => ".", country_code_alpha2 => ".", country_code_alpha3 => ".", country_code_numeric => ".",
    country_name => ".", extended_address => ".", first_name => ".",
    options => { update_existing => "." },
    last_name => ".", locality => ".", postal_code => ".", region => ".", street_address => "."
  };
}

sub credit_card_signature {
  return {
    customer_id => ".",
    billing_address_id => ".", cardholder_name => ".", cvv => ".", expiration_date => ".",
    expiration_month => ".", expiration_year => ".", number => ".", token => ".",
    venmo_sdk_payment_method_code => ".",
    device_session_id => ".",
    device_data => ".",
    options => {
      make_default => ".",
      verification_merchant_account_id => ".",
      verify_card => ".",
      update_existing_token => ".",
      fail_on_duplicate_payment_method => ".",
      venmo_sdk_session => "."
    },
    billing_address => address_signature
  };
}

sub customer_signature {
  return {
    company => ".", email => ".", fax => ".", first_name => ".", id => ".", last_name => ".", phone => ".", website => ".", device_data => ".",
    credit_card => credit_card_signature,
    custom_fields => "_any_key_"
  };
}

sub clone_transaction_signature {
  return { amount => ".", "channel" => ".", options => { submit_for_settlement => "." } };
}

sub transaction_signature{
  return {
    amount => ".", customer_id => ".", merchant_account_id => ".", order_id => ".", channel => ".", payment_method_token => ".", "device_session_id" => ".", "device_data" => ".",
    purchase_order_number => ".", recurring => ".", shipping_address_id => ".", type => ".", tax_amount => ".", tax_exempt => ".",
    credit_card => {token => ".", cardholder_name => ".", cvv => ".", expiration_date => ".", expiration_month => ".", expiration_year => ".", number => "."},
    customer => {id => ".", company => ".", email => ".", fax => ".", first_name => ".", last_name => ".", phone => ".", website => "."} ,
    billing => address_signature,
    shipping => address_signature,
    options => {
      store_in_vault => ".",
      store_in_vault_on_success => ".",
      submit_for_settlement => ".",
      add_billing_address_to_payment_method => ".",
      store_shipping_address_in_vault => ".",
      venmo_sdk_session => ".",
      hold_in_escrow => "."
    },
    custom_fields => "_any_key_",
    descriptor => {name => ".", phone => "."},
    subscription_id => ".",
    venmo_sdk_payment_method_code => ".",
    service_fee_amount => "."
  };
}

sub merchant_account_signature{
  return {
    applicant_details => {
      company_name => ".",
      first_name => ".",
      last_name => ".",
      email => ".",
      phone => ".",
      date_of_birth => ".",
      ssn => ".",
      tax_id => ".",
      routing_number => ".",
      account_number => ".",
      address => {
        street_address => ".",
        postal_code => ".",
        locality => ".",
        region => ".",
      }
    },
    tos_accepted => ".",
    master_merchant_account_id => ".",
    id => "."
  };
}

1;
