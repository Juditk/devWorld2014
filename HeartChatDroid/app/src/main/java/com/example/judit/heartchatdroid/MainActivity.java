package com.example.judit.heartchatdroid;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.util.Log;
import java.lang.String;


public class MainActivity extends Activity {

    JKPeerBrowser mPeerBrowser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Log.v ("Heart chat","for Android started");
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        mPeerBrowser = new JKPeerBrowser(this);
        JKConnection mServerConnection;

        mPeerBrowser.startBrowsingForPeers();
        mPeerBrowser.discoverServices();
        mServerConnection = (new JKConnection());
        try {

            Thread.sleep(5000);
            } catch (InterruptedException e) {
            e.printStackTrace();
        }

        mPeerBrowser.initializeRegistrationListener();
        mPeerBrowser.registerService(mServerConnection.getLocalPort());

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
