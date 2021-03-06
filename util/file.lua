require 'os'
require 'fs'
require 'paths'

function is_file(path)
    return paths.filep(path)
end

function check_file_error(path, msg)
    if not is_file(path) then
        print(msg)
        os.exit()
    end
end

-- Check that a data directory exists, and create it if not.
function check_and_mkdir(dir)
  if not paths.filep(dir) then
    fs.mkdir(dir)
  end
end

-- Decompress a .tgz or .tar.gz file.
function decompress_tarball(path)
   os.execute('tar xvf ' .. path)
end

-- Download the file at location url.
function download_file(url)
  os.execute('wget ' .. url)
end

-- Temporarily changes the current working directory to call fn, returning its
-- result.
function do_with_cwd(path, fn)
    local cur_dir = fs.cwd()
    fs.chdir(path)
    local res = fn()
    fs.chdir(cur_dir)
    return res
end

-- Check that a file exists at path, and if not downloads it from url.
function check_and_download_file(path, url)
  if not paths.filep(path) then
      do_with_cwd(paths.dirname(path), partial(download_file, url))
  end

  return path
end

