class FoldersController < ApplicationController

  def index
    @page_title = 'Folders'
    @show_all_folders = true
    @folders = Shortcut.find_by_sql("select left(shortcut, instr(shortcut, '/') - 1) as folder, count(*) count from shortcuts group by folder having count > 1 and folder != '' order by count desc")
  end

end
