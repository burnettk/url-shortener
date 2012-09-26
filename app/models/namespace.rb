class Namespace
  class << self
    def shortcuts_by_namespace(namespace)
      Shortcut.where(['shortcut like ?', namespace + '/%']).order('shortcut')
    end
  end
end
