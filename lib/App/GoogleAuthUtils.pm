package App::GoogleAuthUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{gen_google_auth_qrcode} = {
    v => 1.1,
    summary => 'Generate Google authenticator QR code (barcode) from a secret key',
    description => <<'_',

When generating a new 2FA token, you are usually presented with a secret key as
well as a 2D barcode (QR code) representation of this secret key. You are
advised to store the secret key and it's usually more convenient to store the
key code instead of the QR code. But when entering the secret key to the Google
authenticator app, it's often more convenient to scan the barcode instead of
typing or copy-pasting the code.

This utility will convert the secret key code into bar code (opened in a
browser) so you can conveniently scan the bar code into your app.

_
    args => {
        secret_key => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
        issuer => {
            schema => 'str*',
            req => 1,
            pos => 1,
        },
        account => {
            schema => 'str*',
            pos => 2,
        },
    },
    examples => [
        {
            args => {
                secret_key => '6XDT6TSOGR5SCWKHXZ4DFBRXJVZGAKAW',
                issuer => 'example.com',
            },
        },
    ],
};
sub gen_google_auth_qrcode {
    require URI::Encode;

    my %args = @_;

    my $url = join(
        '',
        'https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr',
        '&chl=otpauth://totp/', (
            URI::Encode::uri_encode(
                $args{issuer} . ($args{account} ? ":$args{account}" : "")),
            '%3Fsecret%3D', $args{secret_key}, '%26issuer%3D', $args{issuer},
        ),
    );

    require Browser::Open;
    my $err = Browser::Open::open_browser($url);
    return [500, "Can't open browser for '$url'"] if $err;
    [200];
}

1;
#ABSTRACT: Utilities related to Google Authenticator

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

=cut
