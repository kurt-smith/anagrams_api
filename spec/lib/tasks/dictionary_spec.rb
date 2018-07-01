# frozen_string_literal: true

require 'rails_helper'

describe 'dictionary:enqueue', type: :rake_task do
  it 'defaults to 1_000 and enqueues workers' do
    expect(CorpusWorker.jobs.count).to eq(0)
    expect { Rake::Task['dictionary:enqueue'].invoke }.to change(CorpusWorker.jobs, :size).by(1_000)
  end
end
