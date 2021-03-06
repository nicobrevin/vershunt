require 'spec/helpers'

describe 'msp_release status' do
  include_context 'project_helpers'

  describe 'debian', self do
    before do
      init_debian_project 'project', {:version => '0.0.1'}
    end

    it 'does not show any release commit information if you are not on a release commit' do
      in_project_dir 'project' do
        run_msp_release 'status'
        last_run.should exit_with(0)
        last_stdout.should match(/^Release commit +: <none>$/)
        last_stdout.should match(/^Changelog says +: 0\.0\.1$/)
        last_stdout.should match(/^Project says +: 0\.0\.1+/)
      end
    end

    it 'shows release commit information if you are on a release commit' do
      in_project_dir 'project' do
        run_msp_release 'branch'
        run_msp_release 'new'
        run_msp_release 'push'
        run_msp_release 'status'
        last_stdout.should match(/^Release commit +: 0.0.1-1$/)
        last_stdout.should match(/^Changelog says +: 0\.0\.1-1$/)
        last_stdout.should match(/^Project says +: 0\.0\.1+/)
      end
    end
  end

  describe 'gem', self do
    before do
      init_gem_project 'project', {:version => '0.0.1'}
    end

    it 'does not show any release commit information if you are not on a release commit' do
      in_project_dir 'project' do
        run_msp_release 'status'
        last_run.should exit_with(0)
        last_stdout.should match(/^Release commit +: <none>$/)
        last_stdout.should match(/^Project says +: 0\.0\.1+/)
      end
    end

    it 'shows release commit information if you are on a release commit' do
      in_project_dir 'project' do
        run_msp_release 'branch'
        run_msp_release 'new'
        run_msp_release 'push'
        run_msp_release 'status'
        last_stdout.should match(/^Release commit +: 0.0.1$/)
        last_stdout.should match(/^Project says +: 0\.0\.1+/)
      end
    end
  end

end
