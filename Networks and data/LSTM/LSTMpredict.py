import scipy.io as sio # for load matlab data file
from keras.models import load_model
from pandas import DataFrame
import sys

def calLSTM(filename1,filename2):
    print(filename1)    
    #filename = ('Model_Noninterp_case%02d_imont%02d_6432_TS%02d.h5' % (icase, imont, stepsize))
    model = load_model(filename1)
    #filename1 = ('Results_Noninterp_case%02d_imont%02d_6432_TS%02d.mat' % (icase, imont, stepsize))
    dataset = sio.loadmat(filename2, squeeze_me=True, struct_as_record=False)

    testdata = dataset['test']
    blinddata3 = dataset['blinddata3']
    blinddata4 = dataset['blinddata4']
    blinddata5 = dataset['blinddata5']
    icase = 1

    df_test_y = DataFrame(testdata[:, -1])
    loc = df_test_y[df_test_y[0].isin([0/200, 20/200, 60/200, 100/200, 120/200, 200/200])]
    ind = loc.index.tolist()
    select_testdata = testdata[ind]       
    test_X, test_y = select_testdata[:, :-1], select_testdata[:, -1]
    stepsize = 1
    test_X = test_X.reshape((test_X.shape[0], stepsize, test_X.shape[1]))
        
    output = model.predict(test_X)

    # blind case testing
    scaled3 = blinddata3[:,:37]
    scaled4 = blinddata4[:,:37]
    scaled5 = blinddata5[:,:37]

    blind3_X = scaled3.reshape((scaled3.shape[0], 1, scaled3.shape[1]))
    blind4_X = scaled4.reshape((scaled4.shape[0], 1, scaled4.shape[1]))
    blind5_X = scaled5.reshape((scaled5.shape[0], 1, scaled5.shape[1]))

    yblind3 = model.predict(blind3_X)
    yblind4 = model.predict(blind4_X)
    yblind5 = model.predict(blind5_X)

    outputs={}
    outputs['test_output'] = output
    outputs['blind3_output'] = yblind3
    outputs['blind4_output'] = yblind4
    outputs['blind5_output'] = yblind5
    filenames = 'temp.mat'
    sio.savemat(filenames, outputs)
    #return outputs

if __name__ == '__main__':
    x = str(sys.argv[1])
    y = str(sys.argv[2])
	calLSTM(x,y)


