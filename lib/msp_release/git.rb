module MSPRelease::Git

  include MSPRelease::Exec

  def on_master?
    cur_branch == 'master'
  end

  def cur_branch
    /^\* (.+)$/.match(exec "git branch")[1]
  end

  def branch_exists?(branch_name)
    # use backticks, we don't want an error
    `git show-branch origin/#{branch_name}`
    $? == 0
  end

  def create_and_switch(branch_name)
    exec "git branch #{branch_name}"
    exec "git push origin #{branch_name}"
    exec "git checkout #{branch_name}"
  end

  def added_files
    status_files("new file")
  end

  def modified_files
    status_files("modified")
  end

  def status_files(status)
    output = exec "git status", [0,256]
    pattern = /#{status}: +(.+)$/
    output.split("\n").map {|l| pattern.match(l) }.compact.map{|m|m[1]}
  end

  def latest_commit
    commit_output =
      exec "git --no-pager log -1 --no-color --full-index --pretty=short".split("\n")

    commit_pattern = /^commit ([a-z0-9]+)$/
    author_pattern = /^Author: (.+)$/
    message_pattern = /^    (.+)$/

    hash = commit_output.grep(commit_pattern) {|m| commit_pattern.match(m)[1] }.first
    author = commit_output.grep(author_pattern) {|m| author_pattern.match(m)[1] }.first
    message = commit_output.grep(message_pattern).
      map {|row| message_pattern.match(row)[1] }.
      join(" ")

    {:hash => hash, :author => author, :message => message}
  end

  def remote_is_ahead?
    raise NotImplementedError
    branch_name = cur_branch
    exec "git fetch"
    exec "git --no-pager log origin/#{branch_name} --no-color --oneline -1".split("")
  end

  extend self
end
