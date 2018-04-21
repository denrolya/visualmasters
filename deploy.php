<?php

namespace Deployer;

require __DIR__ . '/vendor/deployer/deployer/recipe/symfony3.php';

set('application', 'visualmasters'); // Project name
set('http_user', 'apache');
set('db', [
    'local' => [
        'name' => 'visualmasters',
        'username' => 'root',
        'password' => 'root'
    ],
    'production' => [
        'host' => '46.101.57.96',
        'name' => 'visualmasters',
        'username' => 'visualmasters',
        'password' => 'eMAiBwvAYHY4Gy8e'
    ]
]);
set('local_project_folder', '/Users/drolya/Public/visualmasters'); // In order to use database:copy:to_local

// Hosts
host('production')
    ->hostname(get('db')['production']['host'])
    ->stage('production')
    ->user('drolya')
    ->identityFile('~/.ssh/id_rsa')
    ->multiplexing(true)
    ->set('repository', 'https://github.com/denrolya/visualmasters.git')
    ->set('branch', 'update')
    ->set('clear_paths', [])
    ->set('symfony_env', 'dev')
    ->set('composer_options', 'install --verbose --prefer-dist --no-progress --no-interaction --optimize-autoloader')
    ->set('deploy_path', '/var/www/{{application}}')
    ->set('writable_mode', 'chmod')
    ->set('shared_dirs', ['var/logs', 'var/jwt', 'var/sessions']);

task('database:copy:to_local', function() {
    $dumpFilename = 'dump-' . time() . '.sql';
    $remoteDb = get('db')[input()->getArgument('stage')];
    $localDb = get('db')['local'];

    writeln('<info>Dumping database from remote host.</info>');
    runLocally("mysqldump -h {$remoteDb['host']} -u {$remoteDb['username']} -p{$remoteDb['password']} {$remoteDb['name']} > ./$dumpFilename");

    writeln('<info>Dump success. Exporting dump into local database.</info>');
    runLocally("mysql -u {$localDb['username']} -{$localDb['password']} {$localDb['name']} < ./$dumpFilename");
    writeln('<info>Successfully exported! Removing leftover files...</info>');
    runLocally("rm ./$dumpFilename");

    writeln('<info>Finish!</info>');
})->desc('Copy database from remote stage to local environment');

task('database:copy:to_remote', function() {
    $stage = input()->getArgument('stage');
    if (!askConfirmation('You sure you want to upload your local DB to [' . $stage . ']?')) {
        writeln('<info>Aborted by user!</info>'); die;
    }

    $dumpFilename = 'dump-' . time() . '.sql';
    $remoteDb = get('db')[$stage];
    $localDb = get('db')['local'];

    writeln('<info>Dumping database locally.</info>');
    runLocally("mysqldump -u {$localDb['username']} -p{$localDb['password']} {$localDb['name']} > ./$dumpFilename");

    writeln('<info>Dump complete. Exporting dump into remote database.</info>');
    runLocally("mysql -h {$remoteDb['host']} -u {$remoteDb['username']} -p{$remoteDb['password']} {$remoteDb['name']} < ./$dumpFilename");

    writeln('<info>Successfully exported! Removing leftover files...</info>');
    runLocally("rm ./$dumpFilename");

    writeln('<info>Finish!</info>');
})->desc('Copy local database to remote stage');

task('deploy', [
    'deploy:info',
    'deploy:prepare',
    'deploy:lock',
    'deploy:release',
    'deploy:update_code',
    'deploy:clear_paths',
    'deploy:create_cache_dir',
    'deploy:shared',
    'deploy:assets',
    'deploy:vendors',
    'deploy:assets:install',
    'deploy:assetic:dump',
    'deploy:cache:clear',
    'deploy:cache:warmup',
    'deploy:writable',
    'deploy:symlink',
    'deploy:unlock',
    'cleanup',
])->desc('Deploy backend application');

task('deploy:frontend:vendors','yarn install')->desc('Install frontend dependencies');

after('deploy:failed', 'deploy:unlock');
after('deploy', 'success');