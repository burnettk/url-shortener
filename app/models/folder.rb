class Folder
  class << self
    def shortcuts_by_folder(folder)
      Shortcut.where(['shortcut like ?', folder + '/%']).order('shortcut')
    end
  end
end
