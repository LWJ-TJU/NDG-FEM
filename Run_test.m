function Run_test( varargin )
%RUN_TEST run the tests to verify the model and solver

% Ϊ��ʹ���Ժ���˳��ִ�У����뽫 NDG-FEM ��·����ӵ�����������
addpath(pwd);

if nargin == 0
    test_StdRegions = true;
else
    test_StdRegions = false;
    
    for i = nargin
        switch varargin{i}
            case 'StdRegions'
                test_StdRegions = true;
            otherwise
                error(['No test for %s, please choose one of\n',...
                    '  StdRegions\n'], varargin{i})
        end% switch
    end% for
end% if

if test_StdRegions
    filepath{1} = 'testing/StdRegions/Triangle';
    filepath{2} = 'testing/StdRegions/Quad';
    Test_dir(filepath);
end

end

function Test_dir(filepath)
% TESTDIR ���Ը���·�������в��Խű�
for f = 1:numel(filepath) % ���������ļ�·��
    file = dir(filepath{f});
    for i = 1:numel(file) % ����·���������ļ�
        [~, ~, ext] = fileparts(file(i).name); 
        if strcmp(ext, '.m') % �ļ���׺Ϊ.m��ִ�в���
            results = runtests(fullfile(filepath{f}, file(i).name));
            table(results)
        end
    end
end
end% func