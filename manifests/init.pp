class common_scripts{

  if $fact[os].[family] == 'windows'{

    $common_scripts_dir = "C:\\common_scripts"
    file { $common_scripts_dir:
            ensure => 'directory',
            owner   => 'Administrator',
            group   => 'Administrators',
        }

    ['get-availablePatches.ps1'].each | String $file | {
          file { "${common_scripts_dir}\\${file}" :
            ensure  => 'present',
            owner   => 'Administrator',
            group   => 'Administrators',
            source  => "puppet:///modules/common_scripts/windows/${file}",
            replace => true,
            force   => true,
        }
    }

  }
}
