shared_examples 'invalid params' do |message, model: nil, code: 403|
  context message do
    if model
      it "doesn't create #{model}" do
        expect { subject }.not_to change(model, :count)
      end
    end

    if code
      it "returns #{code}" do
        expect(subject).to have_http_status(code)
      end
    end
  end
end

shared_examples 'unauthorized user request' do |message, **hargs|
  include_context 'unauthorized user'
  include_examples 'invalid params', message, hargs.merge(code: 401)
end

shared_examples 'unauthorized user destroy' do
  include_context 'unauthorized user'
end

shared_examples 'non owner' do
  include_context 'non owner user'
end
