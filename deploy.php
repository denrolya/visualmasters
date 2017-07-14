<?php
namespace Deployer;
require 'recipe/symfony.php';

// Configuration

set('ssh_type', 'native');
set('ssh_multiplexing', true);

set('repository', 'git@github.com:rdenes93/imperiumdesign.git');

add('shared_files', []);
add('shared_dirs', []);

add('writable_dirs', []);
set('writable_mode', 'chmod');

// Servers
server('production', '46.101.57.96')
    ->user('drolya')
    ->identityFile('~/.ssh/id_rsa.pub')
    ->set('branch', 'develop')
    ->set('deploy_path', '/var/www/test')
    ->pty(true);
