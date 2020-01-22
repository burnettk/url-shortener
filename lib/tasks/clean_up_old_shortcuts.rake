desc 'Clean up old shortcuts'
task clean_up_old_shortcuts: :environment do

  # find shortcuts with a most recent visit more than three years ago
  sql = 'select s.id, s.shortcut, s.url from shortcuts s join shortcut_visits sv on sv.shortcut_id = s.id group by s.id having max(sv.created_at) < DATE_SUB(NOW(), INTERVAL 3 YEAR) order by sv.created_at desc'

  Shortcut.find_by_sql(sql).each do |shortcut|
    shortcut.destroy
  end

end
