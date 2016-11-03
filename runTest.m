function runTest( varargin )
%RUNTEST Summary of this function goes here
%   ע�⣬Ϊ��ʹ���Ժ���˳��ִ�У����뽫 NDG-FEM ��·����ӵ�
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
    testDir(filepath);
end

end

function testDir(filepath)
for f = 1:numel(filepath)
    file = dir(filepath{f});
    for i = 3:numel(file)
    %     results = runtests(fullfile(filepath, file(i).name));
        table(runtests(fullfile(filepath, file(i).name)))
    end
end
end% func