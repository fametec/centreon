
%centreon_autodisco_config = (
    # You should change it no ?
    sequential => 1,
    clapi_user => 'admin',
    clapi_password => 'centreon',
    ssh_password => '',
    ssh_extra_options => {
        user => 'centreon',
        sshdir => '/var/www/.ssh/',
        timeout => 60,
    },
);

1;
