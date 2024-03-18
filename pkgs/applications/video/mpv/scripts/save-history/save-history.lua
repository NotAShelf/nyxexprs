local HISTFILE = (os.getenv('XDG_DATA_HOME') or os.getenv('HOME')) .. '/mpv/history.log';

mp.register_event('file-loaded', function()
    local title, fp;

    title = mp.get_property('media-title');
    title = (title == mp.get_property('filename') and "" or (' (%s)'):format(title));

    fp = io.open(HISTFILE, 'a+');
    fp:write(('[%s] %s%s\n'):format(os.date('%Y-%m-%d %X'), mp.get_property('path'), title));
    fp:close();
end)
